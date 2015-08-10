require 'trello'
require 'redmine-ruby'
require 'config'

Config.load_and_set_settings('settings.yml')

Trello.configure do |config|
  config.developer_public_key = Settings.trello.public_key
  config.member_token = Settings.trello.member_token
end

board = Trello::Board.find( Settings.trello.board_id )


redmine = Redmine::Client.new( Settings.redmine.url, Settings.redmine.token )

board.cards.each do |card|
  if card.name.match /^#(\d+)/
    issue = redmine.issues.find($1)
    if issue
      puts "Updating ##{issue.issue[:id]} #{issue.issue[:subject]}"
      card.name = "##{issue.issue[:id]} #{issue.issue[:subject]}"
      card.desc = issue.issue[:description] + "\n\n" + "#{Settings.redmine.url.gsub(/\/$/,'')}/issues/#{issue.issue[:id]}"
      card.save
    end
  end
end
