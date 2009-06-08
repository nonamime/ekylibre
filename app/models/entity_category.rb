class EntityCategory < ActiveRecord::Base

  belongs_to :company
  has_many :entities, :foreign_key=>:category
  has_many :prices, :foreign_key=>:category

  def before_validation
    self.code = self.name.codeize if self.code.blank?
    self.code = self.code[0..7]

    EntityCategory.update_all({:default=>false}, ["company_id=? AND id!=?", self.company_id, self.id||0]) if self.default
  end


  def before_destroy
    EntityCategory.create!(self.attributes.merge({:deleted=>true, :company_id=>self.company_id})) 
  end
  
end
