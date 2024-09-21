Config = {}

Config.UnZipItems = {
    'weapon_knife',
    'weapon_switchblade',
    'weapon_scissors',
}

Config.BagFallOffWait = 3 -- Time before the head bag automatically falls off (in minutes)

Config.ZiptieWiggleAmount = 100 -- Number of times the victim must press "Point" before breaking free from zipties

-- Uses Clothing Menu
Config.BagSelection = 49 -- Mask selection (Default: 49)
Config.BagTexture = 19 -- Mask type (Default: 19)

-- QB-Target Options
Config.TargetOptions = {
    RemoveBag = {
        icon = 'fas fa-mask',
        label = 'Remove Bag',
    },
    CutZiptie = {
        icon = 'fas fa-cut',
        label = 'Cut Ziptie',
    },
}