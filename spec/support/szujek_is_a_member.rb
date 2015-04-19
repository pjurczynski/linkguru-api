shared_context 'szujek is a member' do
  let(:bounded_email) { 'szujek@example.com' }
  let!(:local_szujek) { create(:user, email: bounded_email) }
  let(:slack_szujek) do
    {
      "id" => "U02J1P00M",
      "name" => "szujek_stub",
      "deleted" => false,
      "status" => nil,
      "color" => "684b6c",
      "real_name" => "Jurek Szujkowski",
      "tz" => "Europe/Amsterdam",
      "tz_label" => "Central European Summer Time",
      "tz_offset" => 7200,
      "profile" =>  {
        "first_name" => "Jurek",
        "last_name" => "Szujkowski",
        "image_24" => '',
        "image_32" => '',
        "image_48" => '',
        "image_72" => '',
        "image_192" => '',
        "image_original" => '',
        "skype" => '',
        "title" => "Developer",
        "real_name" => "Jurek Szujkowski",
        "real_name_normalized" => "Jurek Szujkowski",
        "email" => bounded_email,
      },
      "is_admin" => false,
      "is_owner" => false,
      "is_primary_owner" => false,
      "is_restricted" => false,
      "is_ultra_restricted" => false,
      "is_bot" => false,
      "has_files" => true,
      "has_2fa" => false,
    }
  end

  before do
    users = Slack::API::UserList.new.call
    allow_any_instance_of(Slack::API::UserList)
      .to receive(:call).and_return(users.push slack_szujek)
  end
end
