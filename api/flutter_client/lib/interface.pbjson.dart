///
//  Generated code. Do not modify.
//  source: interface.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const CreateRequest$json = const {
  '1': 'CreateRequest',
  '2': const [
    const {'1': 'room_name', '3': 1, '4': 1, '5': 9, '10': 'roomName'},
  ],
};

const CreateReply$json = const {
  '1': 'CreateReply',
  '2': const [
    const {'1': 'room_key', '3': 1, '4': 1, '5': 9, '10': 'roomKey'},
    const {'1': 'host_id', '3': 2, '4': 1, '5': 9, '10': 'hostId'},
  ],
};

const JoinRequest$json = const {
  '1': 'JoinRequest',
  '2': const [
    const {'1': 'room_key', '3': 1, '4': 1, '5': 9, '10': 'roomKey'},
  ],
};

const JoinReply$json = const {
  '1': 'JoinReply',
  '2': const [
    const {'1': 'guest_id', '3': 1, '4': 1, '5': 9, '10': 'guestId'},
  ],
};

const QueueRequest$json = const {
  '1': 'QueueRequest',
  '2': const [
    const {'1': 'room_key', '3': 1, '4': 1, '5': 9, '10': 'roomKey'},
  ],
};

const QueueReply$json = const {
  '1': 'QueueReply',
  '2': const [
    const {'1': 'song_id', '3': 1, '4': 1, '5': 9, '10': 'songId'},
    const {'1': 'service_id', '3': 2, '4': 1, '5': 9, '10': 'serviceId'},
  ],
};

const SongRequest$json = const {
  '1': 'SongRequest',
  '2': const [
    const {'1': 'song', '3': 1, '4': 1, '5': 11, '6': '.liveq.QueueReply', '10': 'song'},
    const {'1': 'room_key', '3': 2, '4': 1, '5': 9, '10': 'roomKey'},
  ],
};

