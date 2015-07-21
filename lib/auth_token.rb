require 'jwt'

module AuthToken
  def AuthToken.issue_token(payload)
    payload[:exp] =   2.weeks.from_now.to_i
    JWT.encode payload, Rails.application.secrets.secret_key_base, 'HS512'
  end

  def AuthToken.valid?(token)
    begin
      decoded_token = JWT.decode token, Rails.application.secrets.secret_key_base, true
    rescue #JWT::ExpiredSignature
      false
    end
  end
end
