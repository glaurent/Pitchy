import Foundation

public struct PitchCalculator {

  // MARK: - Offsets

  public static func offsets(frequency: Double) throws -> Pitch.Offsets {
    let note = try Note(frequency: frequency)
    let higherNote = try note.higher()
    let lowerNote = try note.lower()
    let closestNote = abs(higherNote.frequency - frequency)
      < abs(lowerNote.frequency - frequency)
      ? higherNote
      : lowerNote

    let firstOffset = Pitch.Offset(
      note: note,
      frequency: frequency - note.frequency,
      percentage: (frequency - note.frequency) * 100
        / abs(note.frequency - closestNote.frequency),
      cents: try cents(note.frequency, frequency2: frequency)
    )

    let secondOffset = Pitch.Offset(
      note: closestNote,
      frequency: frequency - closestNote.frequency,
      percentage: (frequency - closestNote.frequency) * 100
        / abs(note.frequency - closestNote.frequency),
      cents: try cents(closestNote.frequency, frequency2: frequency)
    )

    return Pitch.Offsets(firstOffset, secondOffset)
  }

  public static func cents(frequency1: Double, frequency2: Double) throws -> Double {
    guard Validator.isValidFrequency(frequency1)
      && Validator.isValidFrequency(frequency2)
      else { throw Error.InvalidFrequency }

    return 1200.0 * log2(frequency2 / frequency1)
  }
}
