module TokenGenerator
  include JwtToken
  def jwt_token_1(user)
      token =jwt_encode({user_id: user.id})
      token
  end
end