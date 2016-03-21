require 'trello'
require 'redmine-ruby'
require 'config'

def desc_with_url(issue)
  desc = issue.issue[:description] || ""
  return desc + "\n\n" + "#{Settings.redmine.url.gsub(/\/$/,'')}/issues/#{issue.issue[:id]}"
end

Config.load_and_set_settings('settings.yml')

Trello.configure do |config|
  config.developer_public_key = Settings.trello.public_key
  config.member_token = Settings.trello.member_token
end

board = Trello::Board.find( Settings.trello.board_id )

redmine = Redmine::Client.new( Settings.redmine.url, Settings.redmine.token )

# (12) [xxx] #1234 desc
# [   保留 ] #照抄 [sync]
board.cards.each do |card|
  if card.name.match(/#(\d+)/)
    issue      = redmine.issues.find($1)
    components = card.name.split("##{issue.issue[:id]}")
    appendix   = components[0]
    title      = components[1]
    if issue && (title.strip != issue.issue[:subject] || card.desc != desc_with_url(issue))
      puts "Updating ##{issue.issue[:id]} #{issue.issue[:subject]}"
      card.name = "#{appendix} ##{issue.issue[:id]} #{issue.issue[:subject]}".strip
      card.desc = desc_with_url(issue)
      card.save
    else
      puts "Ignoring ##{issue.issue[:id]} #{issue.issue[:subject]}"
    end
  end
end
