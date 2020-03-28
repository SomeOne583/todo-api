class WebhookController < ApplicationController
    before_action :authenticate_user!
    
    def index
        case params[:options][:operation]
        when "c" # Create
            c(params)
        when "r" # Read
            r(params)
        when "u" # Update 
            u(params)
        when "d" # Destroy
            d(params)
        end
    end
    
    private 
    
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
        todo = Todo.find_by id: params[:options][:todo_id]
        params[:options][:new_task] ||= todo[:task]
        params[:options][:new_state] ||= todo[:state]
        params[:options][:new_user_id] ||= current_user[:id]
        if (todo[:state] == "Terminada") || ((todo[:state] == "Nueva") && (params[:options][:new_state] == "Terminada"))
            render json: {"Code": 400, "Details": "This change is impossible"}
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
        end
    end

    def d(params)
        todo = Todo.find_by id: params[:options][:todo_id]
        if todo[:state] == "Terminada"
            render json: {"Code": 400, "Details": "Can't delete that todo"}
            return
        end
        if current_user[:id].to_s == todo[:user_id].to_s
            render json: todo.destroy
        end
    end
end
