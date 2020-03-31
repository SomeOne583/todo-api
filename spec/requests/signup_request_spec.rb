require 'rails_helper'

RSpec.describe "Sign-up", type: :request do
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

    context "new and valid user" do
        before do
            post '/signup', params: params
        end

        it "returns 201" do
            expect(response.status).to eq(201)
        end

        it "returns the user" do
            response_evaluated = eval(response.body)
            expect(response_evaluated).to have_key(:email)
            expect(response_evaluated[:email]).to eq("example@mail.com")
        end
    end

    context "user already exists" do
        before do
            user = User.new(params[:user])
            user.save
            post '/signup', params: params
        end

        it "returns null id" do
            response_evaluated = response.body.gsub(/\\/, "")
            expect(response_evaluated).to match(/{,*"id":null,*/)
        end
    end
end