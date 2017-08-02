class Location < ApplicationRecord
  validates :postal_code, presence: true, uniqueness: true
  has_many :projects

  def self.most_active
    Location.joins(:projects).group(:id).order('project.location_id DESC').first
  end

  def self.top_5_most_active
    sql = 'SELECT locations.*, count(locations.id)
           AS location_count
           FROM "locations"
           INNER JOIN "projects"
           ON "projects"."location_id" = "locations"."id"
           GROUP BY "locations"."id"
           ORDER BY location_count DESC
           LIMIT 5'
    Location.find_by_sql(sql)
  end
end
