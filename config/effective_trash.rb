EffectiveTrash.setup do |config|
  # Configure Database Table
  config.trash_table_name = :trash

  # Admin Screens Layout Settings
  config.layout = 'application'   # All EffectiveTrash controllers will use this layout

  # config.layout = {
  #   trash: 'application',
  #   admin_trash: 'admin',
  # }

  # Enable the /trash, /admin/trash and /trash/:id/restore routes. Doesn't affect acts_as_trashable itself.
  config.routes_enabled = true
end
