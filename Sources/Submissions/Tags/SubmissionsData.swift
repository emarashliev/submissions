import TemplateKit

public extension TagContext {

    /// Encapsulates relevant submissions data that can be used for validation output.
    /// For example when rendering the form.
    public struct SubmissionsData: Encodable {
        public let key: String
        public let value: String?
        public let label: String?
        public let isRequired: Bool
        public let errors: Future<[String]>?
    }

    /// Pulls out any relevant submissions data for the given field using the `FieldCache`.
    ///
    /// - Returns: The submission data related to the given field.
    /// - Throws: When the name of the field is missing.
    public func submissionsData() throws -> SubmissionsData {
        let fieldCache = try requireRequest().fieldCache()

        guard let key = parameters[safe: 0]?.string else {
            throw error(reason: "Invalid parameter type.")
        }

        let field = fieldCache[valueFor: key]
        let errors = fieldCache[errorsFor: key]

        return SubmissionsData(
            key: key,
            value: field?.value,
            label: field?.label,
            isRequired: field?.isRequired ?? false,
            errors: errors
        )
    }
}
