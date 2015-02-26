class NoPossibleMoveError < ArgumentError
end

class NotYourOwnPieceError < NoPossibleMoveError
end
