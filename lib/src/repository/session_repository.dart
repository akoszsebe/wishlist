class SessionRepository {
  static final SessionRepository _singleton = new SessionRepository._internal();

  String _firebaseDeviceId;
  String _authToken;

  factory SessionRepository() {
    return _singleton;
  }

  SessionRepository._internal();

  String getFirebaseDeviceId() => _firebaseDeviceId;

  void setFirebaseDeviceId(firebaseDeviceId) => this._firebaseDeviceId = firebaseDeviceId;

  String getAuthToken() => _authToken;

  void setAuthToken(authToken) => this._authToken = authToken;

  void clear() {
    _firebaseDeviceId = "";
    _authToken = "";
  }
}