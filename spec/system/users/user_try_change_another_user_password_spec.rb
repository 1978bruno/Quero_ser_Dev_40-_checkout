require 'rails_helper'

describe 'usuário tenta trocar senha de outro usuário' do
  it 'e volta para página inicial' do
    # Arrange
    user1 = create(:user, name: 'Usuário Teste1', email: 'user1@locaweb.com.br', password: '12345678')
    user2 = create(:user, name: 'Usuário Teste2', email: 'user2@locaweb.com.br', password: '87654321')

    # Act
    login_as(user1)
    visit(edit_password_users_admin_path(user2.id))

    # Assert
    expect(current_path).to eq root_path
  end
end
