class SellsController < InheritedResources::Base
    belongs_to :prediction, :optional => true
    def create
        params[:sell][:user_id] = current_user.id
        create!
    end
    def accept
        @prediction = Prediction.find(params[:sell][:prediction_id])
        @sell = Sell.find(params[:id])
        @buy = Buy.create(
            price: @sell.price,
            number_of_shares: @sell.number_of_shares,
            user_id: current_user.id,
            prediction_id: @prediction.id
        )
        @transaction = Transaction.create(
            buy_id: @buy.id,
            sell_id: @sell.id,
            number_of_shares: @buy.number_of_shares,
            prediction_id: @prediction.id
        )
        @buy.transaction_id = @transaction.id
        @buy.save
        @sell.transaction_id = @transaction.id
        @sell.save
        flash[:notice] = "Transaction Executed saved!"
        redirect_to prediction_path(@prediction.id)
    end
end
