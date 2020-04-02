require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe "Log out", type: :request do
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

    context 'when session exists' do
        it "returns 204" do
            user = User.new({email: "example@mail.com", password: "123456789"})
            user.save
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            # This will add a valid token for `user` in the `Authorization` header
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
            delete '/logout', headers: auth_headers
            expect(response.status).to eq(204)
        end
    end

    context "when session doesn't exists" do
        it "returns 204" do
            user = User.new({email: "example@mail.com", password: "123456789"})
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            # This will add a valid token for `user` in the `Authorization` header
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
            expect {delete '/logout', headers: auth_headers}
            .to raise_error(NoMethodError, "undefined method `update_column' for nil:NilClass")
        end
    end
end