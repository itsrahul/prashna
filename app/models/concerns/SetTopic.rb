module SetTopic
  include ActiveSupport::Concern

  # included do
    # before_action :set_pbject, only: [:show, :edit, :destroy, :update]
  # end

  def set_topics(list)
    topic_list = []
    topic_list = list.strip.split(/,\s*/).collect{|term| Topic.find_or_initialize_by(name: term.capitalize) }
    # topic_list = list.strip.split(/,\s*/).inject([]) {| all, term| all << Topic.find_or_initialize_by(name: term.capitalize) } 

    #done FIXME_AB: topic_list = list.strip.split(/,\s*/).collect{|term| Topic.find_or_initialize_by(name: term.capitalize) }
    #done FIXME_AB: try with inject
    unless topic_list.blank?
      self.topics = topic_list
    end
  end
end