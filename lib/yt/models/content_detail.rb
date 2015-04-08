require 'yt/models/base'

module Yt
  module Models
    # Encapsulates information about the video content, including the length
    # of the video and an indication of whether captions are available.
    # @see https://developers.google.com/youtube/v3/docs/videos#resource
    class ContentDetail < Base
      attr_reader :data

      def initialize(options = {})
        @data = options[:data]
      end

      # @return [Integer] the duration of the video (in seconds).
      has_attribute :duration, default: 0 do |value|
        to_seconds value
      end

      # @return [Boolean] whether the video is available in 3D.
      has_attribute :stereoscopic?, from: :dimension do |dimension|
        dimension == '3d'
      end

      # @return [Boolean] whether the video is available in high definition.
      has_attribute :hd?, from: :definition do |definition|
        definition == 'hd'
      end

      # @return [Boolean] whether captions are available for the video.
      has_attribute :captioned?, from: :caption do |caption|
        caption == 'true'
      end

      # @return [Boolean] whether the video represents licensed content, which
      #   means that the content has been claimed by a YouTube content partner.
      has_attribute :licensed?, default: false, from: :licensed_content

    private

      # @return [Integer] the duration of the resource as reported by YouTube.
      # @see https://developers.google.com/youtube/v3/docs/videos
      #
      # According to YouTube documentation, the value is an ISO 8601 duration
      # in the format PT#M#S, in which the letters PT indicate that the value
      # specifies a period of time, and the letters M and S refer to length in
      # minutes and seconds, respectively. The # characters preceding the M and
      # S letters are both integers that specify the number of minutes (or
      # seconds) of the video. For example, a value of PT15M51S indicates that
      # the video is 15 minutes and 51 seconds long.
      #
      # The ISO 8601 duration standard, though, is not +always+ respected by
      # the results returned by YouTube API. For instance: video 2XwmldWC_Ls
      # reports a duration of 'P1W2DT6H21M32S', which is to be interpreted as
      # 1 week, 2 days, 6 hours, 21 minutes, 32 seconds. Mixing weeks with
      # other time units is not strictly part of ISO 8601; in this context,
      # weeks will be interpreted as "the duration of 7 days". Similarly, a
      # day will be interpreted as "the duration of 24 hours".
      # Video tPEE9ZwTmy0 reports a duration of 'PT2S'. Skipping time units
      # such as minutes is not part of the standard either; in this context,
      # it will be interpreted as "0 minutes and 2 seconds".
      def to_seconds(iso8601_duration)
        match = iso8601_duration.match %r{^P(?:|(?<weeks>\d*?)W)(?:|(?<days>\d*?)D)(?:|T(?:|(?<hours>\d*?)H)(?:|(?<min>\d*?)M)(?:|(?<sec>\d*?)S))$}
        weeks = (match[:weeks] || '0').to_i
        days = (match[:days] || '0').to_i
        hours = (match[:hours] || '0').to_i
        minutes = (match[:min] || '0').to_i
        seconds = (match[:sec]).to_i
        (((((weeks * 7) + days) * 24 + hours) * 60) + minutes) * 60 + seconds
      end
    end
  end
end