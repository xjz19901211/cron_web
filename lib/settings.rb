class Settings
  extend MineSetting

  load_dir Rails.root.join('config/settings'), Rails.env.to_s
end

