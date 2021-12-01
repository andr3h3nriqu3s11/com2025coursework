class ChangeWalletIconToWalletIcon < ActiveRecord::Migration[5.2]

  def change


    # If not run together with all the other migrations you need to run a db:purge

    remove_column :wallets, :icon

    add_reference :wallets, :wallet_icon

  end

end
