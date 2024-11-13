#[starknet::contract]
mod PointsSystem {
    use starknet::{ContractAddress, get_caller_address};
    use core::traits::Into;

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        PointsAdded: PointsAdded,
        PointsRedeemed: PointsRedeemed,
    }

    #[derive(Drop, starknet::Event)]
    struct PointsAdded {
        user: ContractAddress,
        amount: u256
    }

    #[derive(Drop, starknet::Event)]
    struct PointsRedeemed {
        user: ContractAddress,
        amount: u256
    }

    #[storage]
    struct Storage {
        balances: LegacyMap<ContractAddress, u256>,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
    }

    #[external(v0)]
    fn add_points(ref self: ContractState, to: ContractAddress, amount: u256) {
        assert(amount > 0, 'Amount must be positive');
        
        let current_balance = self.balances.read(to);
        self.balances.write(to, current_balance + amount);

        self.emit(Event::PointsAdded(PointsAdded { user: to, amount }));
    }

    #[external(v0)]
    fn redeem_points(ref self: ContractState, amount: u256) {
        let caller = get_caller_address();
        let current_balance = self.balances.read(caller);
        
        assert(current_balance >= amount, 'Insufficient points');
        
        self.balances.write(caller, current_balance - amount);

        self.emit(Event::PointsRedeemed(PointsRedeemed { user: caller, amount }));
    }

    #[external(v0)]
    fn get_balance(self: @ContractState, user: ContractAddress) -> u256 {
        self.balances.read(user)
    }
}