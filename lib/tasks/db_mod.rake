namespace :db_mod do
  desc "Parses raw_data for tweet favorites count and adds it to each records favorite_count column."
  task faves_count: :environment do
    faves = FavoriteTweet.where(:favorite_count => nil)
    faves.each do |fave|
      raw_data = JSON.parse fave.raw_data
      favorite_count = raw_data['favorite_count']
      fave.favorite_count = favorite_count
      fave.save
    end
  end

end
