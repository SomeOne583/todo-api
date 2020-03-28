class WebhookController < ApplicationController
    before_action :authenticate_user!
    
    def index
        case params[:operation]
        when "sign_up"
            if !params.include? :username
                render json: {"Code": 400, "Details": "There is no username"}
                return
            end
            if !params.include? :password
                render json: {"Code": 400, "Details": "There is no password"}
                return
            end
            sign_up(params)
        when "sign_in"
            # (render json: {"Code": 400, "Details": "There is no username"} and return) if !params.include? :username
            if !params.include? :username
                render json: {"Code": 400, "Details": "There is no username"}
                return
            end
            # (render json: {"Code": 400, "Details": "There is no password"} and return) if !params.include? :password
            if !params.include? :password
                render json: {"Code": 400, "Details": "There is no password"}
                return
            end
            sign_in(params)
        when "c" # Create
            if !params.include? :user_id
                render json: {"Code": 400, "Details": "There is no user_id"}
                return
            end
            if !params.include? :task
                render json: {"Code": 400, "Details": "There is no task"}
                return
            end
            c(params)
        when "r" # Read
            if !params.include? :user_id
                render json: {"Code": 400, "Details": "There is no user_id"}
                return
            end
            r(params)
        when "u" # Update 
            if !params.include? :user_id
                render json: {"Code": 400, "Details": "There is no user_id"}
                return
            end
            if !params.include? :todo_id
                render json: {"Code": 400, "Details": "There is no todo id"}
                return
            end
            if !((params.include? :new_task) || (params.include? :new_state) || (params.include? :new_username))
                render json: {"Code": 400, "Details": "There is nothing to change"}
                return    
            end
            if params.include? :new_username
                user = User.find_by username: params[:new_username]
                if user
                    params[:new_user_id] = user[:id]
                else
                    render json: {"Code": 404, "Details": "User not found"}
                    return
                end
            end
            u(params)
        when "d" # Destroy
            if !params.include? :user_id
                render json: {"Code": 400, "Details": "There is no user_id"}
                return
            end
            if !params.include? :todo_id
                render json: {"Code": 400, "Details": "There is no todo id"}
                return
            end
            d(params)
        else
            render json: {"Code": 400, "Details": "Not allowed root"}
            return
        end
    end
    
    private 
    
    def sign_up(params)
        username_provided = params[:username]
        password_provided = Digest::SHA256::hexdigest(params[:password])
        if User.find_by username: username_provided
            render json: {"Code": 400, "Details": "User already exists"}
            return
        end
        user_params = {
            username: username_provided,
            password: password_provided
        }
        new_user = User.new(user_params)
        new_user.save
        render json: {"Code": 200, "Details": "Added user successfully"}
        return
    end

    def sign_in(params)
        username_provided = params[:username]
        password_provided = Digest::SHA256::hexdigest(params[:password])
        user_stored = User.find_by username: username_provided
        if user_stored
            password_stored = user_stored[:password]
            if password_provided == password_stored
                render json: {"Code": 200, "Details": "Access granted"}
                return
            else
                render json: {"Code": 400, "Details": "Wrong password"}
            end
        else
            render json: {"Code": 404, "Details": "The user doesn´t exist"}
            return
        end
    end

    def c(params)
        task_provided = params[:task]
        user_id = params[:user_id]
        todo_params = {
            task: task_provided,
            state: "Nueva",
            user_id: user_id
        }
        new_todo = Todo.new(todo_params)
        new_todo.save
        render json: {"Code": 200, "Details": "Task added succesfully"}
        return
    end
    
    def r(params)
        todos = []
        Todo.find_each do
            |todo|
            if todo[:user_id].to_s == params[:user_id].to_s
                todos << todo
            end
        end
        render json: {"Code": 200, "Details": "Get todo list success", "todos": todos}
        return
    end
    
    def u(params)
        todo = Todo.find_by id: params[:todo_id]
        params[:new_task] ||= todo[:task]
        params[:new_state] ||= todo[:state]
        params[:new_user_id] ||= params[:user_id]
        if (todo[:state] == "Terminada") || ((todo[:state] == "Nueva") && (params[:new_state] == "Terminada"))
            render json: {"Code": 400, "Details": "This change is impossible"}
            return
        end
        if todo[:user_id].to_s == params[:user_id].to_s
            todo_params = {
                task: params[:new_task],
                state: params[:new_state],
                user_id: params[:new_user_id]
            }
            todo.update(todo_params)
            render json: {"Code": 200, "Details": "Todo updated successfully"}
            return
        else
            render json: {"Code": 401, "Details": "You don't have permission to change that"}
            return
        end
    end

    def d(params)
        todo = Todo.find_by id: params[:todo_id]
        if todo[:state] == "Terminada"
            render json: {"Code": 400, "Details": "Can't delete that todo"}
            return
        end
        if params[:user_id].to_s == todo[:user_id].to_s
            todo.destroy
            render json: {"Code": 200, "Details": "Todo destroyed"}
            return
        else
            render json: {"Code": 401, "Details": "You don't have enough permissions"}
            return
        end
    end
end
