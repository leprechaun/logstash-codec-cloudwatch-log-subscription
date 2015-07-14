# encoding: utf-8
require "logstash/codecs/base"
require "logstash/codecs/spool"
require "logstash/json"
require 'time'

class LogStash::Codecs::CloudWatchLogSubscription < LogStash::Codecs::Spool
	config_name "cloudwatch_log_subscription"

	public
	def decode(data)
		data = LogStash::Json.load(data.force_encoding("UTF-8"))
		super(data['logEvents']) do |event|
			event['cloudwatch-logs'] = {
				:owner => data['owner'],
				:logGroup => data['logGroup'],
				:logStream => data['logStream']
			}
			yield LogStash::Event.new(event)
		end
	end # def decode

end # class LogStash::Codecs::CloudWatchLogSubscription
