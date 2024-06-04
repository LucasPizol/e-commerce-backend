
module Auth
    require_relative '../app/use_cases/auth/login_use_case'
    RSpec.describe "LoginUseCase" do
        let(:token_service) { double('TokenService', encode: 'valid_token') }
        let(:load_cart_use_case) { double('LoadCartUseCase', load: []) }
        let(:user_repo) { double('UserRepository') }
    
        subject { Auth::LoginUseCase.new(token_service, load_cart_use_case, user_repo) }

        fake_user = { id: 1, name: 'John Doe', email: 'john.doe@example.com', phone: "any_phone", document: "any_document", role: "any_role", stripe_id: 1, token: 'valid_token' }

        describe "#login" do
            context "with valid credentials" do
                let (:user) { double(fake_user)}
                before { allow(user_repo).to receive(:find_by).with(email: 'john.doe@example.com').and_return(user) }
                before { allow(user).to receive(:authenticate).with('valid_password').and_return(fake_user) }
        
                it "returns a user object with a token and loaded cart" do
                    expect(subject.login('john.doe@example.com', 'valid_password')).to eq(
                        user: { id: 1, name: 'John Doe', email: 'john.doe@example.com', phone: "any_phone", document: "any_document", role: "any_role", stripe_id: 1, token: 'valid_token' },
                        cart: []
                    )
                end
            end
        end
    end
end