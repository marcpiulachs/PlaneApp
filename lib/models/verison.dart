class Version {
  final int major;
  final int minor;
  final int revision;

  Version(this.major, this.minor, this.revision);

  @override
  String toString() => '$major.$minor.$revision';

  // Método opcional para comparar versiones
  bool isNewerThan(Version other) {
    if (major > other.major) return true;
    if (major == other.major && minor > other.minor) return true;
    if (major == other.major &&
        minor == other.minor &&
        revision > other.revision) {
      return true;
    }
    return false;
  }

  // Método para crear una versión desde una cadena "x.y.z"
  factory Version.fromString(String version) {
    final parts = version.split('.');
    if (parts.length != 3) {
      throw const FormatException('Invalid version format, expected "x.y.z"');
    }

    try {
      final major = int.parse(parts[0]);
      final minor = int.parse(parts[1]);
      final revision = int.parse(parts[2]);

      return Version(major, minor, revision);
    } catch (e) {
      throw const FormatException('Version components must be integers');
    }
  }
}
