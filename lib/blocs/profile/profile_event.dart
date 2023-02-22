abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class EditProfileEvent extends ProfileEvent {}

class ViewPostEvent extends ProfileEvent {
  final int index;

  ViewPostEvent(this.index);
}
