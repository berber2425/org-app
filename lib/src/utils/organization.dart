import 'package:api/api.dart';
import 'package:org_data/org_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrganizationController {
  OrganizationController._();

  static final OrganizationController _instance = OrganizationController._();

  factory OrganizationController() {
    return _instance;
  }

  Fragment$MeOrganization? _org;

  Fragment$MeOrganization get org => _org!;

  bool get isSelected => _org != null;

  bool _initialized = false;

  bool get initialized => _initialized;

  Future<void> initialize() async {
    if (initialized) return;

    final prefs = await SharedPreferences.getInstance();

    final orgId = prefs.getString("org_id");

    if (orgId == null) {
      _initialized = true;
      return;
    }

    GlobalClient().additionalHeaders["x-org-id"] = orgId;

    try {
      final org = await Api.query.us();

      _org = org;

      _initialized = true;
    } catch (e) {
      _org = null;
      _initialized = false;
      await prefs.remove("org_id");
    }
  }

  Future<void> select(String orgId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("org_id", orgId);
    GlobalClient().additionalHeaders["x-org-id"] = orgId;
    _org = null;
    _initialized = false;
    await initialize();
  }

  Future<void> unselect() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("org_id");
    GlobalClient().additionalHeaders.remove("x-org-id");
    _org = null;
    _initialized = false;
  }
}
