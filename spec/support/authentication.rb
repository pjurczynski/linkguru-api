shared_context 'user logged in' do
  before { request.headers['HTTP_TOKEN'] = user.token }
end
