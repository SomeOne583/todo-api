require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe "Webhooks", type: :request do
    let(:host) { Rails.application.credentials.host }

    context 'when authenticated' do
        it "create todo w/o params" do
            user = User.new({email: "example@mail.com", password: "123456789"})
            user.save
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            # This will add a valid token for `user` in the `Authorization` header
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
            params = ApplicationController::render json: {
                options: {
                    operation: "create"
                }
            }
            expect {post '/webhook', headers: auth_headers, params: params}
            .to raise_error(ActionController::ParameterMissing, "param is missing or the value is empty: task")
        end

        it "create todo w/ params" do
            user = User.new({email: "example@mail.com", password: "123456789"})
            user.save
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            # This will add a valid token for `user` in the `Authorization` header
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
            params = ApplicationController::render json: {
                options: {
                    operation: "create",
                    task: "Test"
                }
            }
            post '/webhook', headers: auth_headers, params: params
            response_evaluated = eval(response.body)
            expect(response_evaluated).to have_key(:id)
            expect(response_evaluated).to have_key(:task)
            expect(response_evaluated).to have_key(:user_id)
            expect(response_evaluated[:task]).to eq("Test")
        end

        
        it "read" do
            user = User.new({email: "example@mail.com", password: "123456789"})
            user.save
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            # This will add a valid token for `user` in the `Authorization` header
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
            params = ApplicationController::render json: {
                options: {
                    operation: "read"
                }
            }
            post '/webhook', headers: auth_headers, params: params
            response_evaluated = eval(response.body)
            expect(response_evaluated).to be_instance_of(Array)
        end

        it "update w/o params" do
            user = User.new({email: "example@mail.com", password: "123456789"})
            user.save
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            # This will add a valid token for `user` in the `Authorization` header
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
            params = ApplicationController::render json: {
                options: {
                    operation: "update"
                }
            }
            expect {post '/webhook', headers: auth_headers, params: params}
            .to raise_error(ActionController::ParameterMissing, "param is missing or the value is empty: todo_id")
        end
        
        it "update w/o change" do
            user = User.new({email: "example@mail.com", password: "123456789"})
            user.save
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            # This will add a valid token for `user` in the `Authorization` header
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
            params = ApplicationController::render json: {
                options: {
                    operation: "update",
                    todo_id: 1
                }
            }
            post '/webhook', headers: auth_headers, params: params
            response_evaluated = eval(response.body)
            expect(response_evaluated).to have_key(:error)
            expect(response_evaluated[:error][:body]).to eq("Nothing to change")
        end

        it "update succesfull" do
            user = User.new({id: 1, email: "example@mail.com", password: "123456789"})
            user.save
            todo = Todo.new({id: 1, task: "Test", state: "Nueva", user_id: 1})
            todo.save
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            # This will add a valid token for `user` in the `Authorization` header
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
            params = ApplicationController::render json: {
                options: {
                    operation: "update",
                    todo_id: 1,
                    new_task: "Test2"
                }
            }
            post '/webhook', headers: auth_headers, params: params
            response_evaluated = eval(response.body)
            expect(response_evaluated).to have_key(:id)
            expect(response_evaluated).to have_key(:task)
            expect(response_evaluated).to have_key(:user_id)
            expect(response_evaluated[:task]).to eq("Test2")
        end

        it "destroy w/o params" do
            user = User.new({id: 1, email: "example@mail.com", password: "123456789"})
            user.save
            todo = Todo.new({id: 1, task: "Test", state: "Nueva", user_id: 1})
            todo.save
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            # This will add a valid token for `user` in the `Authorization` header
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
            params = ApplicationController::render json: {
                options: {
                    operation: "destroy"
                }
            }
            expect {post '/webhook', headers: auth_headers, params: params}
            .to raise_error(ActionController::ParameterMissing, "param is missing or the value is empty: todo_id")
        end

        it "destroy w/ params" do
            user = User.new({id: 1, email: "example@mail.com", password: "123456789"})
            user.save
            todo = Todo.new({id: 1, task: "Test", state: "Nueva", user_id: 1})
            todo.save
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            # This will add a valid token for `user` in the `Authorization` header
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
            params = ApplicationController::render json: {
                options: {
                    operation: "destroy",
                    todo_id: 1
                }
            }
            post '/webhook', headers: auth_headers, params: params
            response_evaluated = eval(response.body)
            expect(response_evaluated).to have_key(:id)
            expect(response_evaluated).to have_key(:task)
            expect(response_evaluated).to have_key(:user_id)
            expect(response_evaluated[:task]).to eq("Test")
        end

        it "read notification panel" do
            user = User.new({email: "example@mail.com", password: "123456789"})
            user.save
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            # This will add a valid token for `user` in the `Authorization` header
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
            params = ApplicationController::render json: {
                options: {
                    operation: "notifications"
                }
            }
            post '/webhook', headers: auth_headers, params: params
            response_evaluated = eval(response.body)
            expect(response_evaluated).to be_instance_of(Array)
        end
    end

    context 'when unauthenticated' do
        it "create todo w/o params" do
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            params = ApplicationController::render json: {
                options: {
                    operation: "create"
                }
            }
            post '/webhook', headers: headers, params: params
            response_evaluated = eval(response.body)
            expect(response_evaluated).to have_key(:error)
            expect(response_evaluated[:error]).to eq("You need to sign in or sign up before continuing.")
        end

        it "create todo w/ params" do
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            params = ApplicationController::render json: {
                options: {
                    operation: "create",
                    task: "Test"
                }
            }
            post '/webhook', headers: headers, params: params
            response_evaluated = eval(response.body)
            expect(response_evaluated).to have_key(:error)
            expect(response_evaluated[:error]).to eq("You need to sign in or sign up before continuing.")
        end

        
        it "read" do
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            params = ApplicationController::render json: {
                options: {
                    operation: "read"
                }
            }
            post '/webhook', headers: headers, params: params
            response_evaluated = eval(response.body)
            expect(response_evaluated).to have_key(:error)
            expect(response_evaluated[:error]).to eq("You need to sign in or sign up before continuing.")
        end

        it "update w/o params" do
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            params = ApplicationController::render json: {
                options: {
                    operation: "update"
                }
            }
            post '/webhook', headers: headers, params: params
            response_evaluated = eval(response.body)
            expect(response_evaluated).to have_key(:error)
            expect(response_evaluated[:error]).to eq("You need to sign in or sign up before continuing.")
        end
        
        it "update w/o change" do
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            params = ApplicationController::render json: {
                options: {
                    operation: "update",
                    todo_id: 1
                }
            }
            post '/webhook', headers: headers, params: params
            response_evaluated = eval(response.body)
            expect(response_evaluated).to have_key(:error)
            expect(response_evaluated[:error]).to eq("You need to sign in or sign up before continuing.")
        end

        it "update succesfull" do
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            params = ApplicationController::render json: {
                options: {
                    operation: "update",
                    todo_id: 1,
                    new_task: "Test2"
                }
            }
            post '/webhook', headers: headers, params: params
            response_evaluated = eval(response.body)
            expect(response_evaluated).to have_key(:error)
            expect(response_evaluated[:error]).to eq("You need to sign in or sign up before continuing.")
        end

        it "destroy w/o params" do
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            params = ApplicationController::render json: {
                options: {
                    operation: "destroy"
                }
            }
            post '/webhook', headers: headers, params: params
            response_evaluated = eval(response.body)
            expect(response_evaluated).to have_key(:error)
            expect(response_evaluated[:error]).to eq("You need to sign in or sign up before continuing.")
        end

        it "destroy w/ params" do
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            params = ApplicationController::render json: {
                options: {
                    operation: "destroy",
                    todo_id: 1
                }
            }
            post '/webhook', headers: headers, params: params
            response_evaluated = eval(response.body)
            expect(response_evaluated).to have_key(:error)
            expect(response_evaluated[:error]).to eq("You need to sign in or sign up before continuing.")
        end

        it "read notification panel" do
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            params = ApplicationController::render json: {
                options: {
                    operation: "notifications"
                }
            }
            post '/webhook', headers: headers, params: params
            response_evaluated = eval(response.body)
            expect(response_evaluated).to have_key(:error)
            expect(response_evaluated[:error]).to eq("You need to sign in or sign up before continuing.")
        end
    end
end
    