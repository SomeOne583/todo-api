class WebhookController < ApplicationController
    before_action :authenticate_user!
    
    # def index
    #     case params[:options][:operation]
    #     when "c" # Create
    #         if !params.include? :task
    #             render json: {"Code": 400, "Details": "There is no task"}
    #         else
    #             c(params)
    #         end
    #     when "r" # Read
    #         r(params)
    #     when "u" # Update 
    #         if !params.include? :todo_id
    #             render json: {"Code": 400, "Details": "There is no todo id"}
    #             return
    #         end
    #         if !((params.include? :new_task) || (params.include? :new_state) || (params.include? :new_email))
    #             render json: {"Code": 400, "Details": "There is nothing to change"}
    #             return    
    #         end
    #         if params.include? :new_email
    #             user = User.find_by username: params[:new_email]
    #             if user
    #                 params[:new_user_id] = user[:id]
    #             else
    #                 render json: {"Code": 404, "Details": "User not found"}
    #                 return
    #             end
    #         end
    #         u(params)
    #     when "d" # Destroy
    #         if !params.include? :todo_id
    #             render json: {"Code": 400, "Details": "There is no todo id"}
    #             return
    #         end
    #         d(params)
    #     else
    #         render json: {"Code": 400, "Details": "Not allowed root"}
    #         return
    #     end
    # end
    
    # private 
    
    # def c(params)
    #     task_provided = params[:options][:task]
    #     user_id = current_user[:id]
    #     todo_params = {
    #         task: task_provided,
    #         state: "Nueva",
    #         user_id: user_id
    #     }
    #     new_todo = Todo.new(todo_params)
    #     new_todo.save
    #     render json: {"Code": 200, "Details": "Task added succesfully"}
    # end
    
    # def r(params)
    #     todos = []
    #     Todo.find_each do
    #         |todo|
    #         if todo[:user_id].to_s == params[:user_id].to_s
    #             todos << todo
    #         end
    #     end
    #     render json: {"Code": 200, "Details": "Get todo list success", "todos": todos}
    #     return
    # end
    
    # def u(params)
    #     todo = Todo.find_by id: params[:todo_id]
    #     params[:new_task] ||= todo[:task]
    #     params[:new_state] ||= todo[:state]
    #     params[:new_user_id] ||= params[:user_id]
    #     if (todo[:state] == "Terminada") || ((todo[:state] == "Nueva") && (params[:new_state] == "Terminada"))
    #         render json: {"Code": 400, "Details": "This change is impossible"}
    #         return
    #     end
    #     if todo[:user_id].to_s == params[:user_id].to_s
    #         todo_params = {
    #             task: params[:new_task],
    #             state: params[:new_state],
    #             user_id: params[:new_user_id]
    #         }
    #         todo.update(todo_params)
    #         render json: {"Code": 200, "Details": "Todo updated successfully"}
    #         return
    #     else
    #         render json: {"Code": 401, "Details": "You don't have permission to change that"}
    #         return
    #     end
    # end

    # def d(params)
    #     todo = Todo.find_by id: params[:todo_id]
    #     if todo[:state] == "Terminada"
    #         render json: {"Code": 400, "Details": "Can't delete that todo"}
    #         return
    #     end
    #     if params[:user_id].to_s == todo[:user_id].to_s
    #         todo.destroy
    #         render json: {"Code": 200, "Details": "Todo destroyed"}
    #         return
    #     else
    #         render json: {"Code": 401, "Details": "You don't have enough permissions"}
    #         return
    #     end
    # end
end
