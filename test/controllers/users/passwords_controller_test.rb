require "test_helper"

class Users::PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jerry)
    log_in(@user)
  end

  test "can change password" do
    patch users_change_password_path, params: {
      user: {
        current_password: "password",
        password: "new_password"
      }
    }

    assert_redirected_to profile_path
    assert @user.reload.authenticate("new_password")
  end

  test "error response if current password is incorrect" do
    patch users_change_password_path, params: {
      user: {
        current_password: "not right",
        password: "will_it_work?"
      }
    }

    assert_response :unprocessable_entity
  end

  test "error response if new password is invalid" do
    patch users_change_password_path, params: {
      user: {
        current_password: "password",
        password: "s"
      }
    }
    
    assert_response :unprocessable_entity
  end
end
