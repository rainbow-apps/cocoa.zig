pub const NSControlState = enum(i64) {
    Mixed = -1,
    Off = 0,
    On = 1,
};

pub const NSButtonType = enum(u64) {
    MomentaryLight = 0,
    PushOnPushOff = 1,
    Toggle = 2,
    Switch = 3,
    Radio = 4,
    MomentaryChange = 5,
    OnOff = 6,
    MomentaryPushIn = 7,
    Accelerator = 8,
    MultiLevelAccelerator = 9,
};
