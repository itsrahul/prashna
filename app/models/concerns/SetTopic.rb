module SetTopic
  include ActiveSupport::Concern

  # included do
    # before_action :set_pbject, only: [:show, :edit, :destroy, :update]
  # end

  def set_topics(list)
    topic_list = []
    topic_list = list.strip.split(/,\s*/).collect{|term| Topic.find_or_initialize_by(name: term.capitalize) }

    unless topic_list.blank?
      self.topics = topic_list
    end
  end
end
