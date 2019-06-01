module FieldTest
  module Helpers
    def field_test(experiment, options = {})
      exp = FieldTest::Experiment.find(experiment)

      participants = field_test_participants(options)

      if try(:request)
        if params[:field_test] && params[:field_test][experiment]
          options[:variant] ||= params[:field_test][experiment]
        end

        if FieldTest.exclude_bots?
          options[:exclude] = Browser.new(request.user_agent).bot?
        end

        options[:ip] = request.remote_ip
        options[:user_agent] = request.user_agent
      end

      # cache results for request
      @field_test_cache ||= {}
      @field_test_cache[experiment] ||= exp.variant(participants, options)
    end

    def field_test_converted(experiment, options = {})
      exp = FieldTest::Experiment.find(experiment)

      participants = field_test_participants(options)

      exp.convert(participants, goal: options[:goal])
    end

    def field_test_experiments(options = {})
      participants = field_test_participants(options)
      experiments = {}
      participants.each do |participant|
        FieldTest::Membership.where(participant.where_values).each do |membership|
          experiments[membership.experiment] ||= membership.variant
        end
      end
      experiments
    end

    def field_test_participants(options = {})
      participants = []

      if options[:participant]
        participants << options[:participant]
      else
        # controllers and views
        if try(:request)
          controller = is_a?(ActionController::Base) ? self : try(:controller)

          if controller.respond_to?(:current_user, true)
            user = controller.send(:current_user)
            participants << user if user
          end

          if FieldTest.cookies
            # use cookie
            cookie_key = "field_test"

            token = cookies[cookie_key]
            token = token.gsub(/[^a-z0-9\-]/i, "") if token

            if participants.empty? && !token
              token = SecureRandom.uuid
              cookies[cookie_key] = {value: token, expires: 30.days.from_now}
            end
          else
            # anonymity set
            token = Digest::UUID.uuid_v5(FieldTest::UUID_NAMESPACE, ["visitor", FieldTest.mask_ip(request.remote_ip), request.user_agent].join("/"))
          end

          if token
            participants << token

            # backwards compatibility
            participants << "cookie:#{token}" if FieldTest.legacy_participants
          end
        end

        # mailers
        # TODO try mailer to determine if in mailer context
        message = try(:message)
        if message
          # TODO get user/participant from message

          # TODO remove
          to = message.try(:to).try(:first)
          if to
            participants << to
          end
        end
      end

      FieldTest::Participant.standardize(participants)
    end
  end
end
