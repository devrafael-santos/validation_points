module Admin
  class UsersController < BaseController
    def index
      @users = User.order(:name)
    end

    def update
      @user = User.find(params[:id])
      authorize @user

      if @user == current_user && user_params[:role] == "member"
        redirect_to admin_users_path, alert: "Você não pode remover a si mesmo do grupo de administradores." and return
      end

      if @user.update(user_params)
        redirect_to admin_users_path, notice: "Usuário atualizado com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user = User.find(params[:id])
      authorize @user

      if @user == current_user
        redirect_to admin_users_path, alert: "Você não pode excluir a si mesmo."
      else
        @user.destroy
        redirect_to admin_users_path, notice: "Usuário excluído com sucesso."
      end
    end

    private

    def user_params
      params.expect(user: [ :name, :email, :role, :avatar ])
    end
  end
end
