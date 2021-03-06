# This migration splits the `carts` table in two, moving half of the columns to a `proposals` table, and setting the foreign key on the Carts.
class CreateProposals < ActiveRecord::Migration
  ## http://makandracards.com/makandra/15575-how-to-write-complex-migrations-in-rails ##
  class TempCart < ActiveRecord::Base
    self.table_name = 'carts'
    belongs_to :temp_proposal, foreign_key: 'proposal_id'
  end

  class TempProposal < ActiveRecord::Base
    self.table_name = 'proposals'
    has_one :temp_cart, foreign_key: 'proposal_id'
  end
  ######################################################################################

  def change
    create_table :proposals do |t|
      t.string :status
      t.string :flow
      t.timestamps
    end
    add_reference :carts, :proposal

    reversible do |dir|
      TempCart.reset_column_information
      TempProposal.reset_column_information

      dir.up do
        TempCart.find_each do |cart|
          cart.create_temp_proposal!(
            status: cart.status,
            flow: cart.flow,
            created_at: cart.created_at,
            updated_at: cart.updated_at
          )
          cart.save!
        end
      end

      dir.down do
        TempProposal.find_each do |proposal|
          proposal.temp_cart.update_attributes!(
            status: proposal.status,
            flow: proposal.flow
          )
        end
      end
    end
  end
end
