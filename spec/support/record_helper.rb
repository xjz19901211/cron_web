module Support
  module RecordHelper
    def create_work(name, ext_attrs = {})
      attrs = {name: name, code_lang: 'ruby', code: 'puts 1'}.with_indifferent_access
      attrs.merge!(ext_attrs)

      Work.create!(attrs)
    end

    def create_task(name, ext_attrs = {})
      attrs = {output: name}.with_indifferent_access
      attrs.merge!(ext_attrs)
      attrs[:work] = create_work('aaaa') unless attrs[:work] || attrs[:work_id]

      Task.create!(attrs)
    end

    def create_schedule(name, ext_attrs = {})
      attrs = {name: name, cron: '*/10 * * * *'}.with_indifferent_access
      attrs.merge!(ext_attrs)
      attrs[:work] = create_work('aaaa') unless attrs[:work] || attrs[:work_id]

      Schedule.create!(attrs)
    end

    def create_user(name, ext_attrs = {})
      attrs = {email: "#{name}@email.com", password: 'password'}.with_indifferent_access
      attrs.merge!(ext_attrs)

      User.create!(attrs)
    end

    def fetch_user(name, ext_attrs = {})
      email = "#{name}@email.com"
      User.where(email: email).first || create_user(name, ext_attrs)
    end
  end
end

