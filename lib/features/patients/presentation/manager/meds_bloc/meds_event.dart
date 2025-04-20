part of 'meds_bloc.dart';

abstract class MedsEvent extends Equatable {
  const MedsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllMedsEvent extends MedsEvent {}

class AddMedEvent extends MedsEvent {
  final String name;
  final String dose;
  final String scientificName;
  final String company;
  final String price;

  const AddMedEvent({
    required this.name,
    required this.dose,
    required this.scientificName,
    required this.company,
    required this.price,
  });

  @override
  List<Object?> get props => [name, dose, scientificName, company, price];
}
