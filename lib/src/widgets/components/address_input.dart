import 'package:org_app/src/components/inputs/app_form_field.dart';
import 'package:org_app/src/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:org_data/org_data.dart';
import 'package:sign_flutter/sign_flutter.dart';

class AddressInput extends StatefulWidget {
  const AddressInput({super.key, this.address, this.onChanged});

  final Input$AddressInput? address;

  final Function(Input$AddressInput?)? onChanged;

  @override
  State<AddressInput> createState() => _AddressInputState();
}

class _AddressInputState extends State<AddressInput> with Slot {
  final country = "TR".signal;
  final city = "Sakarya".signal;
  final region = "Geyve".signal;
  final line1 = "".signal;
  final line2 = "".signal;
  final postalCode = "54000".signal;

  bool get isValid {
    return country.value.isNotEmpty &&
        city.value.isNotEmpty &&
        region.value.isNotEmpty &&
        line1Validator(line1.value) == null &&
        line2Validator(line2.value) == null &&
        postalCodeValidator(postalCode.value) == null;
  }

  String? postalCodeValidator(String value) {
    if (value.isEmpty) return null;
    if (value.length != 5) return "Posta kodu 5 haneli olmalıdır";
    try {
      int.parse(value);
    } catch (e) {
      return "Posta kodu sayısal olmalıdır";
    }
    return null;
  }

  String? line1Validator(String value) {
    if (value.isEmpty) return "Bu alan gerekli";
    if (value.length > 100) {
      return "Adres satırı 1 en fazla 100 karakter olmalıdır";
    }
    return null;
  }

  String? line2Validator(String value) {
    if (value.length > 100) {
      return "Adres satırı 2 en fazla 100 karakter olmalıdır";
    }
    return null;
  }

  @override
  void onValue(value) {
    if (widget.onChanged != null) {
      widget.onChanged!(
        isValid
            ? Input$AddressInput(
              country: country.value,
              city: city.value,
              region: region.value,
              line1: line1.value,
              line2: line2.value,
              postal_code: postalCode.value,
            )
            : null,
      );
    }
  }

  @override
  void initState() {
    if (widget.address != null) {
      country.value = widget.address!.country;
      city.value = widget.address!.city;
      region.value = widget.address!.region;
      line1.value = widget.address!.line1;
      line2.value = widget.address!.line2 ?? "";
      postalCode.value = widget.address!.postal_code ?? "";
    }

    country.addSlot(this);
    city.addSlot(this);
    region.addSlot(this);
    line1.addSlot(this);
    line2.addSlot(this);
    postalCode.addSlot(this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children:
          [
                //
                Text(
                  "(Geliştirme Aşamasında) Burada ülke, şehir, bölge(ilçe) seçim alanı bulunacak. Eğer hizmet vermediğimiz bir ülke, bölge seçilirse, \"Sizi bekleme listesine ekleyeceğiz\" mesajı görüntülenecektir.",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.brandRedLight,
                  ),
                ),
                AppTextFormField(
                  label: "Adres Satırı 1",
                  initialValue: line1.value,
                  onChanged: (value) {
                    line1.value = value;
                  },
                  validator: line1Validator,
                ),
                AppTextFormField(
                  label: "Adres Satırı 2",
                  initialValue: line2.value,
                  onChanged: (value) {
                    line2.value = value;
                  },
                  validator: line2Validator,
                ),
                AppTextFormField(
                  label: "Posta Kodu",
                  initialValue: postalCode.value,
                  onChanged: (value) {
                    postalCode.value = value;
                  },
                  validator: postalCodeValidator,
                ),
              ]
              .map(
                (e) => ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                    minWidth: 200,
                  ),
                  child: e,
                ),
              )
              .toList(),
    );
  }
}
