#[cfg(test)]
mod tests {
    use core::traits::Into;
    use starknet::ContractAddress;
    use starknet::contract_address_const;
    use super::PointsSystem;
    use starknet::testing::set_caller_address;

    #[test]
    fn test_add_points() {
        let mut state = PointsSystem::contract_state_for_testing();
        let user = contract_address_const::<1>();
        let amount = 100_u256;

        PointsSystem::add_points(ref state, user, amount);
        
        let balance = PointsSystem::get_balance(@state, user);
        assert(balance == amount, 'Balance should match');
    }

    #[test]
    fn test_redeem_points() {
        let mut state = PointsSystem::contract_state_for_testing();
        let user = contract_address_const::<1>();
        set_caller_address(user);
        
        // Add initial points
        let initial_amount = 100_u256;
        PointsSystem::add_points(ref state, user, initial_amount);
        
        // Redeem half the points
        let redeem_amount = 50_u256;
        PointsSystem::redeem_points(ref state, redeem_amount);
        
        let final_balance = PointsSystem::get_balance(@state, user);
        assert(final_balance == initial_amount - redeem_amount, 'Balance should be reduced');
    }
}