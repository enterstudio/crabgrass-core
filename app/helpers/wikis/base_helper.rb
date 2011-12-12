module Wikis::BaseHelper

  protected

  # this will eventually go away once we move the group/wiki and page/wiki
  # controllers over

  #moved wiki_path method to app/controllers/common/application/paths.rb

  # moved following methods from app/helpers/groups/wikis_helper.rb
  def wiki_locked_notice(wiki)
    return if wiki.document_open_for? current_user

    user = wiki.locker_of(:document).try.name || I18n.t(:unknown)
    error_text = :wiki_is_locked.t(:user => user)
    %Q[<blockquote class="error">#{h error_text}</blockquote>]
  end

  # returns something like
  # 'Version 3 created Fri May 08 12:22:03 UTC 2009 by Blue!'
  def wiki_version_label(version)
    label = :version_number.t(:version => version.version)
    user_name = version.try.user.name || :unknown.t
    label << ' '
    label << :created_when_by.t(:when => full_time(version.updated_at),
      :user => user_name)
    label
  end

  def create_wiki_toolbar(wiki)
   "wikiEditAddToolbar('#{wiki.id.to_s}', function() {#{image_popup_function(wiki)}});"
  end

  def image_popup_function(wiki)
    if wiki.new_record?
      "alert('%s');" % :save_wiki_before_adding_image.t
    else
      modalbox_function new_wiki_asset_path(wiki),
        :title => I18n.t(:insert_image)
    end
  end

  def confirm_discarding_wiki_edit_text_area(text_area_id = nil)
    text_area_id ||= 'wiki_body'
    saving_selectors = ["input[name=break_lock]",
          "input[name=save]",
          "input[name=cancel]",
          "input[name=ajax_cancel]"]
    message = I18n.t(:leave_editing_wiki_page_warning)
    %Q[confirmDiscardingTextArea("#{text_area_id}", "#{message}", #{saving_selectors.inspect});]
  end


  def release_lock_on_unload
    %Q[releaseLockOnUnload(#{@wiki.id},"#{form_authenticity_token}");]
  end


end
