class WebhookController < ApplicationController
    before_action :authenticate_user!

    def index
        case params[:options][:operation]
        when "create"
            params[:options].require(:task)
            create(params)
        when "read"
            read(params)
        when "update"
            params[:options].require(:todo_id)
            if !((params[:options].has_key? :new_task) || (params[:options].has_key? :new_state) || (params[:options].has_key? :new_email))
                custom_render(400, "Nothing to change")
            else
                update(params)
            end
        when "destroy"
            params[:options].require(:todo_id)
            destroy(params)
        when "notifications"
            notifications(params)
        when "delete_notification"
            delete_notification(params)
        end
    end
    
    private

    def webhook_params
        params.require(:options)
        params[:options].require(:operation).permit!
    end
    
    def create(params)
        task_provided = params[:options][:task]
        user_id = current_user[:id]
        todo_params = {
            task: task_provided,
            state: "Nueva",
            user_id: user_id
        }
        new_todo = Todo.new(todo_params)
        if new_todo.save
            render json: new_todo, status: :created
        else
            render json: new_todo.errors
        end
    end
    
    def read(params)
        todos = current_user.todos
        render json: todos
    end
    
    def update(params)
      todo = Todo.find_by id: params[:options][:todo_id]
      if (todo) && (todo.user == current_user)
        if (params[:options].has_key? :new_email) && (params[:options][:new_email] != current_user[:email])
          user = User.find_by email: params[:options][:new_email]
          if !user
            custom_render(404, "The user doesn't exist")
          else
            notification = NotificationPanel.new({
              notification: "El usuario %s te transfirió una tarea" % current_user[:email],
              user_id: user[:id]
            })
            notification.save
            params[:options][:new_state] = "Nueva"
            params[:options][:new_user_id] = user[:id]
          end
        end
        params[:options][:new_task] ||= todo[:task]
        params[:options][:new_state] ||= todo[:state]
        params[:options][:new_user_id] ||= current_user[:id]
        if (todo[:state] == "Terminada") || ((todo[:state] == "Nueva") && (params[:options][:new_state] == "Terminada"))
          custom_render(400, "Can't go from new to finished")
        end
        todo_params = {
          task: params[:options][:new_task],
          state: params[:options][:new_state],
          user_id: params[:options][:new_user_id]
        }
        if todo.update(todo_params)
          render json: todo
        else
          render json: todo.errors
        end
      else
        custom_render(404, "Todo not found")
      end
    end

    def destroy(params)
        todo = Todo.find_by id: params[:options][:todo_id]
        if (todo) && (todo.user == current_user)
            if todo[:state] == "Terminada"
                custom_render(400, "Can't delete a finished task")
            end
            todo.destroy
        else
            custom_render(404, "Todo not found")
        end
    end

    def notifications(params)
        notifications = current_user.notification_panels
        render json: notifications
    end

    def delete_notification(params)
        notification = NotificationPanel.find_by id: params[:options][:notification_id]
        if (notification) && (notification.user == current_user)
            notification.destroy
        else
            custom_render(404, "Notification not found")
        end
    end
end
