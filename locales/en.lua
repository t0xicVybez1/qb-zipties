local Translations = {
    error = {
        missing_item = 'You are missing a required item.',
        cant_bag = 'You can\'t put a bag on this person right now.',
        cant_zip = 'You can\'t ziptie this person right now.',
        no_zip_item = 'You have nothing to cut the ziptie with.',
        none_nearby = 'There is nobody nearby.',
        hands_not_up = 'The person must have their hands up.',
        already_bagged = 'This person already has a bag on their head.',
        already_ziptied = 'This person is already ziptied.',
        too_far = 'You are too far away.',
    },
    info = {
        wiggle_free = 'Press [G] repeatedly to attempt to break free.',
        bagged = 'A bag has been put over your head.',
        ziptied = 'You have been ziptied.',
    },
    success = {
        bag_removed = 'The bag has been removed from your head.',
        wiggled_bag_off = 'You managed to get the bag off.',
        ziptie_removed = 'The zipties have been cut off.',
        wiggled_free = 'You managed to break free from the zipties.',
    },
    target = {
        put_bag = 'Put bag on head',
        remove_bag = 'Remove head bag',
        use_ziptie = 'Use ziptie',
        cut_ziptie = 'Cut ziptie',
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})

return Translations