class UnprocessableEntityException < StandardError
    def initialize(msg)
        super(msg)
    end

    def status
        :unprocessable_entity
    end
end