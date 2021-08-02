class ApplicationController < ActionController::Base

  before_action :set_current_user
# ログインしている場合名前を表示させるやつ
def set_current_user
  @current_user = User.find_by(id: session[:user_id])
end
 
# ログインせずにURL直接入力で活かせないようにするやつ
def authenticate_user
  if @current_user == nil
  flash[:notice] = "ログインが必要です"
  redirect_to("/login")
  end
end

def forbid_login_user
  if @current_user
    flash[:notice] = "すでにログインしています"
    redirect_to("/posts")
  end
end

end
