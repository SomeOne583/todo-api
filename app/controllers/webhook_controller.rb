class WebhookController < ApplicationController
    before_action :authenticate_user!

    def index
        case params[:options][:operation]
        when "c" # Create
            params[:options].require(:task)
            c(params)
        when "r" # Read
            r(params)
        when "u" # Update 
            params[:options].require(:todo_id)
            if !((params[:options].has_key? :new_task) || (params[:options].has_key? :new_state) || (params[:options].has_key? :new_email))
                custom_render(400, "Nothing to change")
            else
                u(params)
            end
        when "d" # Destroy
            params[:options].require(:todo_id)
            d(params)
        when "n" # Read notifications
            n(params)
        end
    end
    
    private

    def webhook_params
        params.require(:options)
        params[:options].require(:operation).permit!
    end
    
    def c(params)
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
    
    def r(params)
        todos = []
        Todo.find_each do
            |todo|
            if todo[:user_id].to_s == current_user[:id].to_s
                todos << todo
            end
        end
        render json: todos
    end
    
    def u(params)
        if params[:options].has_key? :new_email
            user = User.find_by email: params[:options][:new_email]
            if !user
                custom_render(404, "The user doesn't exist")
            else
                notification = NotificationPanel.new(
                    {
                        notification: "El usuario %s te transfirió una tarea" % current_user[:email],
                        user_id: user[:id]
                    }
                )
                notification.save
                params[:options][:new_state] = "Nueva"
                params[:options][:new_user_id] = user[:id]
            end
        end
        todo = Todo.find_by id: params[:options][:todo_id]
        if todo
            params[:options][:new_task] ||= todo[:task]
            params[:options][:new_state] ||= todo[:state]
            params[:options][:new_user_id] ||= current_user[:id]
            if (todo[:state] == "Terminada") || ((todo[:state] == "Nueva") && (params[:options][:new_state] == "Terminada"))
                custom_render(400, "Can't go from new to finished")
            end
            if todo[:user_id].to_s == current_user[:id].to_s
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
                custom_render(401, "You don't have permission")
            end
        else
            custom_render(404, "Todo not found")
        end
    end

    def d(params)
        todo = Todo.find_by id: params[:options][:todo_id]
        if todo
            if todo[:state] == "Terminada"
                custom_render(400, "Can't delete a finished task")
            end
            if current_user[:id].to_s == todo[:user_id].to_s
                render json: todo.destroy
            else
                custom_render(401, "You don't have permission")
            end
        else
            custom_render(404, "Todo not found")
        end
    end

    def n(params)
        notifications = []
        NotificationPanel.find_each do
            |notification|
            if notification[:user_id].to_s == current_user[:id].to_s
                notifications << notification
            end
        end
        render json: notifications
    end
end
