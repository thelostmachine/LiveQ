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
    const {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.liveq.Status', '10': 'status'},
    const {'1': 'room_key', '3': 2, '4': 1, '5': 9, '10': 'roomKey'},
    const {'1': 'host_id', '3': 3, '4': 1, '5': 9, '10': 'hostId'},
  ],
};

const KeyRequest$json = const {
  '1': 'KeyRequest',
  '2': const [
    const {'1': 'room_key', '3': 1, '4': 1, '5': 9, '10': 'roomKey'},
  ],
};

const JoinReply$json = const {
  '1': 'JoinReply',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.liveq.Status', '10': 'status'},
    const {'1': 'room_name', '3': 2, '4': 1, '5': 9, '10': 'roomName'},
    const {'1': 'guest_id', '3': 3, '4': 1, '5': 9, '10': 'guestId'},
  ],
};

const ServiceRequest$json = const {
  '1': 'ServiceRequest',
  '2': const [
    const {'1': 'room_key', '3': 1, '4': 1, '5': 9, '10': 'roomKey'},
    const {'1': 'service', '3': 2, '4': 1, '5': 11, '6': '.liveq.ServiceMsg', '10': 'service'},
  ],
};

const Status$json = const {
  '1': 'Status',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 5, '10': 'status'},
  ],
};

const ServiceMsg$json = const {
  '1': 'ServiceMsg',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

const SongMsg$json = const {
  '1': 'SongMsg',
  '2': const [
    const {'1': 'song_id', '3': 1, '4': 1, '5': 9, '10': 'songId'},
    const {'1': 'uri', '3': 2, '4': 1, '5': 9, '10': 'uri'},
    const {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'artist', '3': 4, '4': 1, '5': 9, '10': 'artist'},
    const {'1': 'image_uri', '3': 5, '4': 1, '5': 9, '10': 'imageUri'},
    const {'1': 'duration', '3': 6, '4': 1, '5': 5, '10': 'duration'},
    const {'1': 'service', '3': 7, '4': 1, '5': 9, '10': 'service'},
  ],
};

const SongRequest$json = const {
  '1': 'SongRequest',
  '2': const [
    const {'1': 'song', '3': 1, '4': 1, '5': 11, '6': '.liveq.SongMsg', '10': 'song'},
    const {'1': 'room_key', '3': 2, '4': 1, '5': 9, '10': 'roomKey'},
  ],
};

