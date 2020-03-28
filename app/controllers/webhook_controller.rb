class WebhookController < ApplicationController
    before_action :authenticate_user!
    
    def index
        case params[:options][:operation]
        when "c" # Create
            if !(params[:options].has_key? :task)
                render json: {
                    "error": {
                        "code": 400,
                        "body": "No task supplied"
                    }
                } and return
            else
                c(params)
            end
        when "r" # Read
            r(params)
        when "u" # Update 
            if !(params[:options].has_key? :todo_id)
                render json: {
                    "error": {
                        "code": 400,
                        "body": "No todoID supplied"
                    }
                } and return
            elsif !((params[:options].has_key? :new_task) || (params[:options].has_key? :new_state) || (params[:options].has_key? :new_email))
                render json: {
                    "error": {
                        "code": 400,
                        "body": "Nothing to change"
                    }
                } and return
            else
                if params[:options].has_key? :new_email
                    user = User.find_by email: params[:options][:todo_id]
                    if !user
                        render json: {
                            "error": {
                                "code": 404,
                                "body": "The user doesn't exist"
                            }
                        } and return
                    end
                end
                u(params)
            end
        when "d" # Destroy
            if !(params[:options].has_key? :todo_id)
                render json: {
                    "error": {
                        "code": 400,
                        "body": "No todoID supplied"
                    }
                } and return
            else
                d(params)
            end
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
            render json: {
                "error": {
                    "code": 400,
                    "body": "Can't go from new to finished"
                }
            } and return
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
            render json: {
                "error": {
                    "code": 400,
                    "body": "Can't delete a finished task"
                }
            } and return
        end
        if current_user[:id].to_s == todo[:user_id].to_s
            render json: todo.destroy
        end
    end
end
