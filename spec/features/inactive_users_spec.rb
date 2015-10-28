feature "Inactive users" do
  scenario "not included in approving official dropdown" do
    inactive_approving_official = create(:user, :inactive)
    active_approving_official = create(:user, :active)
    user = create(:user)
    login_as(user)

    visit new_ncr_work_order_path

    expect(page).to have_content(active_approving_official.email_address)
    expect(page).not_to have_content(inactive_approving_official.email_address)
  end
end
