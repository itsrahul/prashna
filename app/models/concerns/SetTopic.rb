module SetTopic
  include ActiveSupport::Concern

  def set_topics(list)
    topic_list = []
    topic_list = list.strip.split(/,\s*/).collect{|term| Topic.find_or_initialize_by(name: term.capitalize) }

    if not topic_list.blank?
      self.topics = topic_list
    end
  end
end
