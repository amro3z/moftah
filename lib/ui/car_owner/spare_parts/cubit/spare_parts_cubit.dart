import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/car_owner/spare_part_model.dart';
import 'package:moftah/ui/car_owner/spare_parts/cubit/spare_parts_state.dart';
import 'package:moftah/data/store/vehicle_selection_store.dart';

class SparePartsCubit extends Cubit<SparePartsState> {
  SparePartsCubit()
      : super(
          SparePartsState(
            products: _demoProducts,
            vehicles: VehicleSelectionStore.instance.userVehicles,
            selectedVehicleId: VehicleSelectionStore.instance.selectedUserVehicle.id,
          ),
        );

  void syncVehiclesFromAccount() {
    final store = VehicleSelectionStore.instance;
    emit(
      state.copyWith(
        vehicles: store.userVehicles,
        selectedVehicleId: store.selectedUserVehicle.id,
      ),
    );
  }

  void search(String value) => emit(state.copyWith(searchQuery: value));

  void toggleCompatibleOnly() =>
      emit(state.copyWith(compatibleOnly: !state.compatibleOnly));

  void setSort(SparePartsSort value) => emit(state.copyWith(sort: value));

  void setVehicle(String vehicleId) {
    VehicleSelectionStore.instance.selectUserVehicleById(vehicleId);
    emit(
      state.copyWith(
        vehicles: VehicleSelectionStore.instance.userVehicles,
        selectedVehicleId: vehicleId,
      ),
    );
  }

  void toggleFavorite(String productId) {
    final next = {...state.favoriteIds};
    if (!next.add(productId)) next.remove(productId);
    emit(state.copyWith(favoriteIds: next));
  }

  void addToCart(String productId) {
    final next = {...state.cartQuantities};
    next[productId] = (next[productId] ?? 0) + 1;
    emit(state.copyWith(cartQuantities: next));
  }

  void decreaseCart(String productId) {
    final next = {...state.cartQuantities};
    final current = next[productId] ?? 0;
    if (current <= 1) {
      next.remove(productId);
    } else {
      next[productId] = current - 1;
    }
    emit(state.copyWith(cartQuantities: next));
  }

  void removeFromCart(String productId) {
    final next = {...state.cartQuantities}..remove(productId);
    emit(state.copyWith(cartQuantities: next));
  }

  void clearCart() => emit(state.copyWith(cartQuantities: const {}));

  SparePartModel? productById(String id) {
    for (final product in state.products) {
      if (product.id == id) return product;
    }
    return null;
  }

  static const List<SparePartModel> _demoProducts = [
    SparePartModel(
      id: 'bosch-coil',
      name: 'Bosch Ignition Coil',
      brand: 'Bosch',
      category: 'Ignition',
      oemNumber: '014 504 221 0',
      price: 1250,
      rating: 4.8,
      distanceKm: 3.2,
      seller: 'Auto Parts Store',
      location: 'مدينة نصر، القاهرة',
      warrantyMonths: 12,
      imageUrl: 'https://images.unsplash.com/photo-1487754180451-c456f719a1fc?auto=format&fit=crop&w=900&q=80',
      isOem: true,
      isOriginal: true,
      compatibleWithSelectedVehicle: true,
      compatibility: [
        SparePartCompatibility(
          vehicleName: 'Hyundai Elantra',
          years: [2017, 2018, 2019, 2020],
          engine: '1600 CC - كافة مستويات التشطيب',
        ),
      ],
    ),
    SparePartModel(
      id: 'bosch-filter',
      name: 'فلتر زيت بوش',
      brand: 'Bosch',
      category: 'Filters',
      oemNumber: '0986 AF0 123',
      price: 180,
      rating: 4.9,
      distanceKm: 3.2,
      seller: 'Auto Parts Store',
      location: 'مدينة نصر، القاهرة',
      warrantyMonths: 6,
      imageUrl: '',
      isOem: false,
      isOriginal: true,
      compatibleWithSelectedVehicle: true,
      compatibility: [
        SparePartCompatibility(
          vehicleName: 'Hyundai Elantra',
          years: [2017, 2018, 2019, 2020],
          engine: '1600 CC',
        ),
      ],
    ),
    SparePartModel(
      id: 'ngk-plug',
      name: 'بوجيه NGK',
      brand: 'NGK',
      category: 'Ignition',
      oemNumber: 'LZKR6B-10E',
      price: 320,
      rating: 4.7,
      distanceKm: 5.1,
      seller: 'عالم قطع الغيار',
      location: 'مصر الجديدة، القاهرة',
      warrantyMonths: 3,
      imageUrl: '',
      isOem: true,
      isOriginal: true,
      compatibleWithSelectedVehicle: true,
      compatibility: [
        SparePartCompatibility(
          vehicleName: 'Hyundai Elantra',
          years: [2016, 2017, 2018],
          engine: '1600 CC',
        ),
      ],
    ),
    SparePartModel(
      id: 'brake-pads',
      name: 'تيل فرامل أمامي',
      brand: 'Brembo',
      category: 'Brakes',
      oemNumber: 'P30 073',
      price: 1450,
      rating: 4.6,
      distanceKm: 7.4,
      seller: 'Car Zone Parts',
      location: 'المعادي، القاهرة',
      warrantyMonths: 12,
      imageUrl: '',
      isOem: false,
      isOriginal: true,
      compatibleWithSelectedVehicle: false,
      compatibility: [
        SparePartCompatibility(
          vehicleName: 'Kia Cerato',
          years: [2018, 2019, 2020],
          engine: '1600 CC',
        ),
      ],
    ),
  ];
}
