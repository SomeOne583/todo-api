require 'rails_helper'

RSpec.describe "Log in", type: :request do
    let(:host) { 'localhost:3000' }
    let(:params) {
        {
            user: {
                id: 1,
                email: "example@mail.com",
                password: "123456789"
            }
        }
    }

    context "valid login" do
        before do
            user = User.new(params[:user])
            user.save
            post '/login', params: params    
        end

        it "returns 201" do
            expect(response.status).to eq(200)
        end

        it "has authorization header" do
            expect(response.headers).to have_key("Authorization")
        end
    end

    context "invalid login" do
        before do
            post '/login', params: params
        end

        it "returns 401" do
            expect(response.status).to eq(401)
        end
    end
end
